configs = farm
output_dir = "./output"

all: $(configs)

$(configs):
	jsonnetfmt -i $@.jsonnet
	jsonnet -y $@.jsonnet > $(output_dir)/$@.yml

install:
	kubectl apply -f $(output_dir)/*.yml

clean:
	rm -rf $(OUTPUT_DIR)/*
