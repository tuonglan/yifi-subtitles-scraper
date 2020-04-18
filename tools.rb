require 'open-uri'
require 'zip'


module Tools
    LANG_CODES = {
        'English' => 'eng',
        'Vietnamese' => 'vie',
        'Korean' => 'kor',
        'French' => 'fre',
        'Japanese' => 'jap',
        'Chinese' => 'chi',
        'Thailand' => 'thai',
        'Spanish' => 'spa'
    }

    def self.lang_to_code lang
        return LANG_CODES[lang] if LANG_CODES[lang]
        return 'unk'
    end

    class SubDownloader
        def initialize logger:
            @logger = logger
        end

        def down link, mp4_path, lang
            # Get file extension format: ".zip" or ".rar"
            @logger.debug "Preparing metadata..."
            ext = File.extname link
            base_path = File.join(File.dirname(mp4_path), File.basename(mp4_path, File.extname(mp4_path)))
            lang_code = Tools::lang_to_code lang
            
            # Download and process
            @logger.debug "Downloading file #{link}..."
            open(link) do |sin|
                # If the file is ".zip"
                if ext == '.zip'
                    zip = Zip::InputStream.new sin
                    while entry = zip.get_next_entry
                        sub_ext = File.extname entry.name
                        extract_file = "#{base_path}.#{lang_code}#{sub_ext}"
                        @logger.debug "Found #{entry.name}, extracting to #{extract_file}..."
                        entry.extract extract_file
                    end
                elsif ext == '.rar'
                    raise Exception.new "RAR format of #{link} will be supported in the future"
                else
                    raise Exception.new "Format of link #{link} is not supported"
                end
            end
        end
    end
end
