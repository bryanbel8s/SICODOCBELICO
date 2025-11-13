# api/python/utils_sql.py

import pyodbc

def get_connection():
    """Conecta a SQL Server y devuelve la conexión"""
    conn = pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"  # Cambia si usas otro host o IP
        "DATABASE=SICODOC;"
        "UID=sa;"
        "PWD=tu_contraseña;"
    )
    return conn
