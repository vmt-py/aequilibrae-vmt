# Usar una imagen base de Python con Ubuntu
FROM python:3.11-slim

# Establecer el directorio de trabajo
WORKDIR /workspace

# Actualizar el sistema e instalar dependencias del sistema
RUN apt-get update -y && \
    apt-get install -y \
    libsqlite3-mod-spatialite \
    libspatialite-dev \
    build-essential \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Actualizar pip
RUN pip install --upgrade pip

# Instalar JupyterLab y AequilibraE
RUN pip install \
    jupyterlab \
    aequilibrae \
    numpy \
    pandas \
    matplotlib \
    geopandas \
    folium \
    mapclassify \
    plotly \
    seaborn \
    contextily \
    rasterio \
    fiona

# Crear un directorio para los notebooks
RUN mkdir -p /workspace/notebooks

# Configurar JupyterLab para permitir acceso desde cualquier IP
RUN jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.port = 8888" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.open_browser = False" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_root = True" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.token = ''" >> ~/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.password = ''" >> ~/.jupyter/jupyter_lab_config.py

# Exponer el puerto 8888
EXPOSE 8888

# Cambiar al directorio de notebooks
WORKDIR /workspace/notebooks

# Comando por defecto para iniciar JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]