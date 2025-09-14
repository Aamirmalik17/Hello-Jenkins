FROM python:3.11-slim

#set working dir

WORKDIR /app

#copy requiremennt and install dependencies

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

#copy application code

COPY app.py .

#expose port

EXPOSE 5000

# Run the application 

CMD ["python" , "app.py"]
