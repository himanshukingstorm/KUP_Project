FROM python:3.8.10
COPY . .
RUN pip3 install flask flask-SQLAlchemy
CMD ["python3" "app.py"]
