import sys
import csv

from spinedb import SpineDB

input_db_url = sys.argv[1]
output_db_url = sys.argv[2]
translation_file = sys.argv[3]

input_db = SpineDB(input_db_url)
output_db = SpineDB(output_db_url, create=True)

# Export data from input db
input_data = input_db.export_data()

renames = dict()

# Open and read renames file
with open(translation_file) as csvfile:
    for row in csv.reader(csvfile):
        renames[row[0].strip()] = row[1].strip()
        
    
def translate_spine_data(input_data: dict, renames: dict) -> dict:
    """Translate Spine data renaming classes and parameters
    """
    
    def rename(old_label):
        return renames.get(old_label, old_label)
    
    # Create new data by renames
    translated = {
        'object_classes': [
            (rename(obj_class[0]),) + obj_class[1:]
            for obj_class in input_data['object_classes']
        ],
        'relationship_classes': [
            (
                rename(rel_class[0]), 
                [rename(obj_class) for obj_class in rel_class[1]],
                rel_class[2]
            )
            for rel_class in input_data['relationship_classes']
        ],
        'object_parameters': [
            (rename(obj_par[0]), rename(obj_par[1])) + obj_par[2:]
            for obj_par in input_data['object_parameters']
        ],
        'objects': [
            (rename(obj[0]), ) + obj[1:]
            for obj in input_data['objects']
        ],
        'relationships': [
            (rename(rel[0]), rel[1]) for rel in input_data['relationships']
        ],
        'object_parameter_values': [
            (
                rename(par_value[0]), 
                par_value[1], 
                rename(par_value[2])
            ) + par_value[3:]
            for par_value in input_data['object_parameter_values']
        ],
#        'features': [
#            (
#                rename(feature[0]),
#                rename(feature[1]),
#                rename(feature[2]),
#                feature[3]
#            )
#            for feature in input_data['features']
#        ],
#        'tool_features': [
#            (
#                tool_feature[0],
#                rename(tool_feature[1]),
#                rename(tool_feature[2]),
#                tool_feature[3],
#            )
#            for tool_feature in input_data['tool_features']
#        ],
    }

    # Pass through keys which are not renamed
    for key in (set(input_data.keys()) - set(translated.keys())):
        translated.update({key: input_data[key]})

    return translated


translated_data = translate_spine_data(input_data, renames)

# Store to output db
output_db.import_data(translated_data)
output_db.commit("Translate from Master data")
