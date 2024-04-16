from airflow.decorators import dag, task
from datetime import datetime

from astro import sql as aql
from astro.files import File
from astro.sql.table import Table

from include.dbt.cosmos_config import DBT_PROJECT_CONFIG, DBT_CONFIG
from cosmos.airflow.task_group import DbtTaskGroup
from cosmos.constants import LoadMode
from cosmos.config import RenderConfig

from airflow.models.baseoperator import chain



@dag(
    start_date=datetime(2024, 1, 1),
    schedule='@daily',
    catchup=False,
    tags=['retail']
)
def retail():

    load_retail_to_snowflake = aql.load_file(
        
        task_id='load_retail_to_snowflake',
        input_file = File(
            path='https://raw.githubusercontent.com/abdullah-khaled0/ELT-Pipeline-with-Airflow-DBT-Soda-Snowflake/main/include/dataset/online_retail.csv'
        ),
        output_table = Table(
            name='raw_invoices',
            conn_id = 'snowflake_default'
        )
    )

    @task.external_python(python='/usr/local/airflow/soda_venv/bin/python')
    def check_load(scan_name='check_load', checks_subpath='sources'):
        from include.soda.checks.check_function import check

        return check(scan_name, checks_subpath)
    

    transform = DbtTaskGroup(
        group_id='transform',
        project_config=DBT_PROJECT_CONFIG,
        profile_config=DBT_CONFIG,
        render_config=RenderConfig(
            load_method=LoadMode.DBT_LS,
            select=['path:models/transform']
        )
    )


    # @task.external_python(python='/usr/local/airflow/soda_venv/bin/python')
    # def check_transform(scan_name='check_transform', checks_subpath='transform'):
    #     from include.soda.checks.check_function import check

    #     return check(scan_name, checks_subpath)
    


    report = DbtTaskGroup(
        group_id='report',
        project_config=DBT_PROJECT_CONFIG,
        profile_config=DBT_CONFIG,
        render_config=RenderConfig(
            load_method=LoadMode.DBT_LS,
            select=['path:models/report']
        )
    )

    @task.external_python(python='/usr/local/airflow/soda_venv/bin/python')
    def check_report(scan_name='check_report', checks_subpath='report'):
        from include.soda.checks.check_function import check

        return check(scan_name, checks_subpath)
    

    chain(
        load_retail_to_snowflake,
        check_load(),
        transform,
        # check_transform(),
        report,
        check_report()
    )


retail()

