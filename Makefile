.PHONY: help build build-base check-modules start stop restart shell local-start push-gcp update-gcp

PORT=80
IMAGE_NAME="univesp.pi20250s1g10"
IMAGE_BASE="univesp.pi20250s1g10-base-image"

PROJECT_NAME=univesp-420315
SERVICE_NAME=univesp-pi20250s1g10
SERVICE_REGION=us-central1
container=$(docker ps -a -q --filter ancestor=${IMAGE_NAME} --format="{{.ID}}")

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build: ## Build Application
	@docker build -t ${IMAGE_NAME} --no-cache . -f ./Dockerfile

build-base: ## Build Base Image
	@docker build -t ${IMAGE_BASE} --no-cache . -f ./Dockerfile.base

check-modules:
	docker run --rm ${IMAGE_NAME} php -m

start: ## Start container
	@echo "Starting container at http://localhost:${PORT}..."
	@docker run -e PORT=${PORT} -p ${PORT}:${PORT} ${IMAGE_NAME}

stop: ## Stop container
	@echo "Stopping container..."
	@docker rm $(shell docker stop $(shell docker ps -a -q --filter ancestor=${IMAGE_NAME} --format="{{.ID}}"))

restart: stop start ## Restart container

shell: ## SSH into container
	@docker exec -it $(shell docker ps -a -q --filter ancestor=${IMAGE_NAME} --format="{{.ID}}") /bin/ash

local-start: ##Start laravel project using artisan
	php ./src/artisan serve

push-gcp: ##Push application image to Container Registry on GCP
	make build
	gcloud config set project ${PROJECT_NAME}
	docker tag ${IMAGE_NAME} gcr.io/${PROJECT_NAME}/${IMAGE_NAME}
	docker push gcr.io/${PROJECT_NAME}/${IMAGE_NAME}

update-gcp: ##Update Google Cloud Run Service with new image
	gcloud run services update ${SERVICE_NAME} --image=gcr.io/${PROJECT_NAME}/${IMAGE_NAME}:latest --region=${SERVICE_REGION}
