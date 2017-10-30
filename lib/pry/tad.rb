require 'pry/tad/version'

require 'tempfile'
module Pry
  # namespace
  module Tad
    module_function

    # temporary file name
    def tmp_name
      Time.now.strftime('%Y%m%d%H%M%S')
    end

    # temporory file path with name
    def tmp_file_path
      File.join(Dir.tmpdir, "#{tmp_name}.csv")
    end

    def start_tad(filename)
      return if system('tad', filename)
      $stderr.puts <<-TEXT
Couldn't start `tad` make sure it is installed.
Install on OSX using:
```sh
brew install cask
brew cask install tad
```
      TEXT
    end

    def run(argf: ARGF)
      run_argf if argf
    end

    def run_argf(argf)
      if argf.filename == '-'
        File.open(tmp_file_path, 'wb') do |f|
          while (chunk = argf.read(1024 * 8))
            f.write(chunk)
          end
          start_tad(f.path)
        end
      else
        start_tad(argf.filename)
      end
    end
  end
end
