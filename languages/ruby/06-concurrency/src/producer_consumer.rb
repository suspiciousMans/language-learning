# ---------- Simple producer-consumer with Queue ----------
puts "=== Producer-Consumer with Queue ==="

queue = Queue.new
SHUTDOWN_MSG = :shutdown
NUM_ITEMS = 10

producer = Thread.new do
  NUM_ITEMS.times do |i|
    item = "item-#{i}"
    queue << item
    puts "  Produced: #{item}"
    sleep(0.05)
  end
  queue << SHUTDOWN_MSG
  puts "  Producer done"
end

consumer = Thread.new do
  processed = []
  loop do
    item = queue.pop
    break if item == SHUTDOWN_MSG
    processed << item.upcase
    puts "  Consumed: #{item} -> #{item.upcase}"
    sleep(0.08)
  end
  puts "  Consumer done, processed #{processed.size} items"
  processed
end

producer.join
processed = consumer.value
puts "  All processed: #{processed.inspect}"

# ---------- Multiple producers, single consumer ----------
puts "\n=== Multiple producers, single consumer ==="

queue = Queue.new
NUM_PRODUCERS = 3
ITEMS_PER_PRODUCER = 5
mutex = Mutex.new
total_produced = 0

producers = NUM_PRODUCERS.times.map do |pid|
  Thread.new do
    ITEMS_PER_PRODUCER.times do |i|
      item = "p#{pid}-item-#{i}"
      queue << item
      mutex.synchronize { total_produced += 1 }
      sleep(0.03)
    end
  end
end

consumer = Thread.new do
  consumed = []
  remaining = NUM_PRODUCERS * ITEMS_PER_PRODUCER
  remaining.times do
    item = queue.pop
    consumed << item
    sleep(0.06)
  end
  consumed
end

producers.each(&:join)
consumed = consumer.value

puts "  Total produced: #{total_produced}"
puts "  Total consumed: #{consumed.size}"
puts "  All items uniquely consumed: #{consumed.uniq.size == consumed.size}"
puts "  First few: #{consumed.first(5).inspect}"

# ---------- Worker pool pattern ----------
puts "\n=== Worker pool pattern ==="

NUM_WORKERS = 3
TASK_COUNT = 10

def work(item)
  sleep(0.05)
  "#{item}-result"
end

queue = Queue.new
results = []
results_mutex = Mutex.new

workers = NUM_WORKERS.times.map do |wid|
  Thread.new do
    loop do
      item = queue.pop
      break if item == :shutdown
      result = work(item)
      results_mutex.synchronize { results << result }
    end
  end
end

TASK_COUNT.times { |i| queue << "task-#{i}" }
NUM_WORKERS.times { queue << :shutdown }
workers.each(&:join)

puts "  Submitted #{TASK_COUNT} tasks to #{NUM_WORKERS} workers"
puts "  Collected #{results.size} results"
puts "  Results: #{results.sort.inspect}"
