marketing-shell: ## Run a shell on the marketing site container
	docker exec -it edx.devstack.marketing env TERM=$(TERM) bash

up-marketing:   ## Bring up all services (including the marketing site) with host volumes
	docker-compose -f docker-compose.yml -f docker-compose-host.yml -f docker-compose-marketing-site.yml -f docker-compose-marketing-site-host.yml up

up-marketing-detached:   ## Bring up all services (including the marketing site) with host volumes (in detached mode)
	docker-compose -f docker-compose.yml -f docker-compose-host.yml -f docker-compose-marketing-site.yml -f docker-compose-marketing-site-host.yml up -d
