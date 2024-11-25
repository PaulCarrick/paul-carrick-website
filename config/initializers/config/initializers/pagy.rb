require "pagy/extras/array"
require "pagy/extras/overflow"

Pagy::DEFAULT[:items] = 5
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT.freeze
