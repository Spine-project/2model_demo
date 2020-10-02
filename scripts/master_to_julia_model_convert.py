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
    'operating_cost': 'op_cost'
}

translated_data = {
    'object_classes': [
        ('grid_node', None, 280376907920706),
        ('powerplant', '', 281472107868789)
    ],
    'relationship_classes': [
        ('powerplant__grid_node', ['powerplant', 'grid_node'], None)],
   'object_parameters': [
        ('grid_node', 'demand', None, None, None),
        ('powerplant', 'net_capacity', None, None, None),
        ('powerplant', 'operating_cost', None, None, None)],
   'objects': [
        ('grid_node', 'node 1', None),
        ('powerplant', 'plant A', None),
        ('powerplant', 'plant B', None)],
    'relationships': [
        ('powerplant__grid_node', ['plant A', 'node 1']),
        ('powerplant__grid_node', ['plant B', 'node 1'])],
    'object_parameter_values': [
        ('grid_node', 'node 1', 'demand', 150.0, 'Base'),
        ('powerplant', 'plant A', 'net_capacity', 100.0, 'Base'),
        ('powerplant', 'plant A', 'operating_cost', 25.0, 'Base'),
        ('powerplant', 'plant B', 'net_capacity', 200.0, 'Base'),
        ('powerplant', 'plant B', 'operating_cost', 50.0, 'Base')],
    'alternatives': [
        ('Base', 'Base alternative')
    ]
}

# Store to output db
output_db.import_data(output_data)
