create-kind-cluster:
	@echo "Creating cluster..."
	kind create cluster --name kong-fc --config kind/config.yaml
	oc cluster-info --context kind-kong-fc

install-kong: create-kind-cluster
	@echo "Install Kong..."
	kubectl create ns kong
	# helm repo add kong https://charts.konghq.com
	helm install kong kong/kong -f ./kong/kong-config.yaml \
		--set proxy.type=NodePort,proxy.http.nodePort=30000,proxy.tls.nodePort=30003 \
		--set ingressController.installCRDs=false \
		--set serviceMonitor.enabled=true \
		--set serviceMonitor.labels.release=promstack \
		--namespace kong

clean:
	@echo "Deleting cluter"
	kind delete clusters kong-fc


