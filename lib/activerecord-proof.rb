class ActiveRecordProof
  attr :name, :watcher

  def self.guard name, &blk
    proof = ActiveRecordProof.new name # XXX try self.new
    proof.run &blk
  end

  def initialize name
    @name = name
    @watcher = StringIO.new
  end

  def run
    record_all_activerecord_logs
    yield
    save_logs
    no_diffs_allowed!
  end

  require 'active_record'
  require 'logger'
  def record_all_activerecord_logs
    ActiveRecord::Base.logger = Logger.new watcher
  end

  def save_logs
    got = denoise watcher.string
    File.write proof_filename, got
  end

  def denoise str
    str.gsub(/Load \([\d.]+ms\)/, 'Load (SomeMilliseconds)')
     .sub(/D, \[.+?\] DEBUG -- :\s*/, '')
     .sub(/\e\[3[56]/, "\e[35")
  end

  class Diff < RuntimeError; end
  require 'shellwords'
  def no_diffs_allowed!
    clean_name = Shellwords.escape proof_filename
    return unless system 'git diff --quiet ' + clean_name
    raise Diff, `git diff #{clean_name}`
  end

  def proof_filename; 'test/proof-'+name end
end

