module Parity
  class Usage
    def to_s
      File.read(readme).match(/Usage\n-----\n([^\/.]*)Convention/)[1]
    end

    private

    def readme
      File.join(File.dirname(__FILE__), '..', '..', 'README.md')
    end
  end
end
