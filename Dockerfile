FROM quay.io/astronomer/astro-runtime:11.0.0

RUN python -m venv soda_venv && source soda_venv/bin/activate && \
    pip install --no-cache-dir soda-core-snowflake==3.3.1 &&\
    pip install --no-cache-dir soda-core-scientific==3.3.1 && deactivate


RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-snowflake==1.7.3 && deactivate
