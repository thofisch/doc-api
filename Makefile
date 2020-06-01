.PHONY: dev
dev: ## edit documentation
	@docker-compose up -d

.PHONY: deploy
deploy: ## deploy documentation to github pages
	@docker run --rm -it \
		-v ~/.ssh:/root/.ssh \
		-v ${PWD}:/docs \
		squidfunk/mkdocs-material:4.1.2 \
		gh-deploy --clean --config-file ./mkdocs.yml

.PHONY: help
help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
