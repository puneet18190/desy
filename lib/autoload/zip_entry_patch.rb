module ZipEntryPatch

  def write_to_zip_output_stream_with_entry_args_fix(aZipOutputStream)
    if @ftype == :directory
      aZipOutputStream.put_next_entry(self)
    elsif @filepath
      aZipOutputStream.put_next_entry(self, nil, nil, nil)
      get_input_stream { |is| IOExtras.copy_stream(aZipOutputStream, is) }
    else
      aZipOutputStream.copy_raw_entry(self)
    end
  end

  def self.included(included)
    included.send :alias_method_chain, :write_to_zip_output_stream, :entry_args_fix
  end

end

Zip::ZipEntry.send(:include, ZipEntryPatch)