import yaml
import mysql.connector
import pandas as pd


def mysql_connect(user, password, host, database):
    return mysql.connector.connect(user=user, password=password, host=host, database=database, ssl_disabled=True)


def mysql_close(connection):
    connection.close()


def build_json_lines(conn, sql_file):
    with open(sql_file, 'r') as f:
        df = pd.read_sql(f.read(), conn)
        json_data = df.to_json(orient='records', lines=True) # this configuration creates json as a new line

    return json_data


def write_json_lines(json_lines, target_file):
    with open(target_file, 'w') as f:
        f.write(json_lines)


def build_and_write_csv(conn, sql_file, target_file):
    with open(sql_file, 'r') as f:
        df = pd.read_sql(f.read(), conn)
        df.to_csv(target_file, index=False)


if __name__ == '__main__':
    with open("connections/mysql_connection.yaml", "r") as f:
        conf = yaml.load(f, Loader=yaml.FullLoader)

    conn = mysql_connect(user=conf['user'], password=conf['password'], host=conf['host'], database=conf['database'])

    # JSON files
    for dataset in ['dataset1_per_msa_code', 'dataset2_per_state', 'dataset3_per_zip_code']:
        sql_file, target_file = f'./sqls/{dataset}.sql', f'./output_files/{dataset}.json'

        try:
            json_lines = build_json_lines(conn=conn, sql_file=sql_file)
            write_json_lines(json_lines=json_lines, target_file=target_file)
            print(f"The dataset {dataset} generated successfully!")
        except Exception as e:
            print(f"The dataset {dataset} wasn't generated")
            print(f'caught {type(e)}: e')

    # CSV files
    for dataset in ['dataset4_state_year_data']:
        sql_file, target_file = f'./sqls/{dataset}.sql', f'./output_files/{dataset}.csv'
        try:
            build_and_write_csv(conn=conn, sql_file=sql_file, target_file=target_file)
            print(f"The dataset {dataset} generated successfully!")
        except Exception as e:
            print(f"The dataset {dataset} wasn't generated")
            print(f'caught {type(e)}: e')

    mysql_close(conn)




