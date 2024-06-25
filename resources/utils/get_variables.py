import yaml

def get_variables(source_name, env):
    file_path = f'.\configurations\e2e\{source_name}.yaml'
    with open(file_path, 'r') as file:
        content = yaml.safe_load(file)
    return content[env]
