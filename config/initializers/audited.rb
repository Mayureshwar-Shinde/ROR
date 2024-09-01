require "audited"

Audited::Railtie.initializers.each(&:run)
# Audited.max_audits = 10