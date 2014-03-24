QC_CONFIG = YAML.load_file("#{::Rails.root}/config/qc.yml")[::Rails.env]

ENV["DATABASE_URL"] = QC_CONFIG["database_url"]