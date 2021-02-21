FROM ubuntu:20.04

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/London"

RUN apt-get update -y \
    && apt install python3 -y \
    && apt install python3-pip -y \
    && apt install python3-venv -y \
    && apt install tesseract-ocr -y \
    && python3 -m venv venv


#RUN apt-get update -y \
#    && apt install -y libswscale-dev \
#        libtbb2 \
#        libtbb-dev \
#        libjpeg-dev \
#        libpng-dev \
#        libtiff-dev \
#        libavformat-dev \
#        libpq-dev

#RUN apt-get update -y \
#    && apt install -y libxcb-glx0 libgl1 libgl1-mesa-dri libglapi-mesa libglib2.0-0 libglib2.0-data libglvnd0 libglx-mesa0 \
#    libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-randr0 libxcb-render0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-xfixes0 libxcb1

#RUN apt-get update -y \
#    && apt install -y ffmpeg libsm6 libxext6

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app/imageproc.py .
CMD ["python", "-m robot", "/opt/app/image.robot"]
