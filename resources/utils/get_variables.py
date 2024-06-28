import os
import yaml

def get_variables(source_name, env):
    file_path = os.path.join('configurations', 'e2e', f'{source_name}.yaml')
    with open(file_path, 'r') as file:
        content = yaml.safe_load(file)
    return content[env]
