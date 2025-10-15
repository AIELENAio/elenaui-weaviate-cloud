#!/bin/bash
set -e

echo "🚀 Starting MPNet model server..."
python3 -m sentence_transformers.SentenceTransformerServer \
  --model_name sentence-transformers/all-mpnet-base-v2 \
  --port 8081 &
sleep 10

echo "🚀 Starting InstructorXL model server..."
python3 -m sentence_transformers.SentenceTransformerServer \
  --model_name hkunlp/instructor-xl \
  --port 8082 &
sleep 10

echo "🚀 Starting BGE model server..."
python3 -m sentence_transformers.SentenceTransformerServer \
  --model_name BAAI/bge-base-en \
  --port 8083 &
sleep 10

echo "🧠 Launching Weaviate..."
/usr/local/bin/weaviate \
  --host 0.0.0.0 \
  --port 8080 \
  --scheme http \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true \
  --env QUERY_DEFAULTS_LIMIT=25 \
  --env PERSISTENCE_DATA_PATH=/var/lib/weaviate \
  --env ENABLE_MODULES=text2vec-transformers,text2vec-instructor,text2vec-bge \
  --env DEFAULT_VECTORIZER_MODULE=text2vec-transformers \
  --env TRANSFORMERS_INFERENCE_API=http://localhost:8081 \
  --env INSTRUCTOR_INFERENCE_API=http://localhost:8082 \
  --env BGE_INFERENCE_API=http://localhost:8083
