nombre-del-proyecto/
├── data/
│   ├── raw/                # Archivos originales que recibiste
│   └── processed/          # Los CSV limpios que exportaremos
├── notebooks/
│   ├── 01_limpieza_y_eda.ipynb       # Limpieza y Análisis Exploratorio
│   ├── 02_creacion_base_datos.ipynb  # Migración a SQL y Modelo Estrella
│   └── 03_consultas_sql.ipynb        # Resolución de preguntas de negocio
├── sql/
│   └── script_creacion.sql           # El código SQL puro (opcional para respaldo)
├── dashboard/                        # Archivo de Power BI / Tableau
├── web_app/                          # Integración web
├── README.md                         # Documentación en inglés
└── requirements.txt                  # Librerías (pandas, matplotlib, sqlalchemy)
