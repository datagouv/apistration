class DeferredGarbageCollection
  DEFERRED_GC_THRESHOLD = ENV.fetch('DEFER_GC', 15.0).to_f

  @@last_gc_run = Time.zone.now

  def self.start
    GC.disable if DEFERRED_GC_THRESHOLD.positive?
  end

  def self.reconsider
    return unless DEFERRED_GC_THRESHOLD.positive? && Time.zone.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD

    GC.enable
    GC.start
    GC.disable
    @@last_gc_run = Time.zone.now
  end
end
