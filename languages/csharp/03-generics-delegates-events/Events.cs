// Exercise 3: Events
// Events are a special kind of delegate — multicast, wrapped with event keyword
// Publishers raise events; subscribers register handlers with +=

using System;

// Custom event args — carry data with the event
public class TemperatureEventArgs : EventArgs
{
    public double Temperature { get; }
    public DateTime Timestamp { get; }

    public TemperatureEventArgs(double temperature)
    {
        Temperature = temperature;
        Timestamp = DateTime.Now;
    }
}

// 2. Publisher class — raises events
public class Thermostat
{
    // Event declaration — wrapping a multicast delegate
    // EventHandler<T> is the standard pattern
    public event EventHandler<TemperatureEventArgs>? TemperatureChanged;

    private double _currentTemperature;

    public double CurrentTemperature
    {
        get => _currentTemperature;
        set
        {
            if (_currentTemperature != value)
            {
                _currentTemperature = value;
                // Raise the event — null-safe invocation
                TemperatureChanged?.Invoke(this, new TemperatureEventArgs(value));
            }
        }
    }
}

// Another publisher — uses a custom delegate type
public delegate void StockPriceChangedHandler(string symbol, double oldPrice, double newPrice);

public class StockTracker
{
    // Custom delegate-based event
    public event StockPriceChangedHandler? PriceChanged;

    private Dictionary<string, double> _prices = new();

    public void UpdatePrice(string symbol, double newPrice)
    {
        if (_prices.TryGetValue(symbol, out var oldPrice))
        {
            if (oldPrice != newPrice)
            {
                PriceChanged?.Invoke(symbol, oldPrice, newPrice);
            }
        }
        _prices[symbol] = newPrice;
    }
}

// 3. Subscriber — subscribes to events with lambda or method
public class TemperatureAlert
{
    public TemperatureAlert(Thermostat thermostat, double threshold)
    {
        thermostat.TemperatureChanged += (sender, args) =>
        {
            if (args.Temperature > threshold)
            {
                Console.WriteLine($"ALERT: Temperature {args.Temperature:F1}°C exceeds {threshold}°C at {args.Timestamp:HH:mm:ss}");
            }
        };
    }
}

public class PriceDisplay
{
    public void Subscribe(StockTracker tracker)
    {
        tracker.PriceChanged += (symbol, oldPrice, newPrice) =>
        {
            double change = newPrice - oldPrice;
            string direction = change >= 0 ? "▲" : "▼";
            Console.WriteLine($"Stock {symbol}: {direction} {Math.Abs(change):F2} (old: {oldPrice:F2}, new: {newPrice:F2})");
        };
    }
}

// Subscriber that unsubscribes
public class PriceLogger
{
    private readonly StreamWriter _log;

    public PriceLogger()
    {
        _log = new StreamWriter("prices.log");
    }

    public void Subscribe(StockTracker tracker)
    {
        tracker.PriceChanged += OnPriceChanged;
    }

    public void Unsubscribe(StockTracker tracker)
    {
        tracker.PriceChanged -= OnPriceChanged;
    }

    private void OnPriceChanged(string symbol, double oldPrice, double newPrice)
    {
        _log.WriteLine($"{DateTime.Now}: {symbol} {oldPrice:F2} -> {newPrice:F2}");
    }

    public void Close() => _log.Close();
}

class Program
{
    static void Main()
    {
        // Thermostat example
        Console.WriteLine("=== Thermostat Events ===");
        var thermostat = new Thermostat();
        var alert = new TemperatureAlert(thermostat, 30.0);

        thermostat.CurrentTemperature = 25.0;   // No alert
        thermostat.CurrentTemperature = 32.0;   // Alert!
        thermostat.CurrentTemperature = 28.0;   // No alert
        thermostat.CurrentTemperature = 35.5;   // Alert!

        // Stock tracker example
        Console.WriteLine("\n=== Stock Events ===");
        var tracker = new StockTracker();
        var display = new PriceDisplay();
        display.Subscribe(tracker);

        tracker.UpdatePrice("AAPL", 150.00);
        tracker.UpdatePrice("AAPL", 152.50);
        tracker.UpdatePrice("GOOG", 2800.00);
        tracker.UpdatePrice("AAPL", 149.00);
    }
}
