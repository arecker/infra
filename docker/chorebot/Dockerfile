FROM python:3
MAINTAINER Alex Recker <alex@reckerfamily.com>
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD [ "python", "./chorebot.py" ]
