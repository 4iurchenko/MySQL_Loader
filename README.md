# DatasetGenerator
DatasetGenerator is an application, written in Python and SQL, for internal usage to generate different dataset files 
from the corporate database(s). Currently, it supports only MySQL and generates 4 different datasets in JSON and CSV formats.

## Installation
1. Download the latest version of the code from the repository
2. Run `pip install -r requirements.txt`
3. Ask the Infra team the file `mysql_connection.yaml` and put in the folder "connections"

## Usage
To update datasets, run `main.py` from the IDE or `python3 main.py` from terminal. 
The generated datasets will be in the folder "output_files".

## Roadmap / Future expansion
To make the app more functional and convenient, the following can be added:
- [ ] Add a median for the datasets 1-3 for the most of the metrics according to requirements
- [ ] Add a configuration file to select which pipelines to run
- [ ] Add the additional connectors to the other databases
- [ ] Add the additional types of datasets

To make it more stable on the system level, the following can be implemented:
- [ ] Add unit tests for the important functions
- [ ] Add a logger when run on a production server
- [ ] Add as a separate package as the library with all custom functions to be able to reuse them 

## Folder structure
- "conne**ctions" - separates the security information and is added to .gitignore
- "output_files" - is used only for the generated datasets
- "sqls" - separates the extraction logic, keeping it in a simple sql files. To be consistent, names of the sql file and output dataset file should begin similarly.

## Decisions Log
- `SQL` and pandas.read_sql() was selected as a much easier way to write, change, understand transformation logic, instead of operations on top of dataframe.
- `YAML` was selected as a much readable and easy-modifiable way to have configs.
- `mysql.connector` was selected as an alternative to Alchemy because of it's simplicity on the initial stage and maaturity.
- `Pandas` was selected because of relatively small amount of data, simplicity, rich framework to save files as JSON, CSV, others.

## Contributing**
Pull requests are welcome. For major changes, please open an issue 
to discuss what you would like to change. And remember, simplicity 
and consistency should be an essential part of the implementation of a new logic.