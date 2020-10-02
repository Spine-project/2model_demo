import sys

from spinedb import SpineDB


input_db_url = sys.argv[1]
output_db_url = sys.argv[2]

input_db = SpineDB(input_db_url)
output_db = SpineDB(output_db_url, create=True)

# Export data from input db
input_data = input_db.export_data()

RENAMES = {
    'grid_node': 'node',
    'powerplant': 'unit',
    'net_capacity': 'capacity',
    'operating_cost': 'op_cost',
    'powerplant__grid_node': 'unit__node',
    'demand': 'elec_load',
}
    
def translate_spine_data(input: dict, renames: dict) -> dict:
    """Translate Spine data renaming classes and parameters
    """
    
    def rename(old_label):
        return renames.get(old_label, old_label)
        
    return {
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
                rename(par_value[2]), 
                par_value[3]
            )
            for par_value in input_data['object_parameter_values']
        ],
        'alternatives': input_data['alternatives']
    }

translated_data = translate_spine_data(input_data, RENAMES)

# Store to output db
output_db.import_data(translated_data)
output_db.commit("Translate from Master data")
