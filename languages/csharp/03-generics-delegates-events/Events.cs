// Exercise 3: Events

using System;
using System.Collections.Generic;

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

public class Thermostat
{
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
                TemperatureChanged?.Invoke(this, new TemperatureEventArgs(value));
            }
        }
    }
}

public delegate void StockPriceChangedHandler(string symbol, double oldPrice, double newPrice);

public class StockTracker
{
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

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Thermostat Events ===");
        var thermostat = new Thermostat();
        var alert = new TemperatureAlert(thermostat, 30.0);

        thermostat.CurrentTemperature = 25.0;
        thermostat.CurrentTemperature = 32.0;
        thermostat.CurrentTemperature = 28.0;
        thermostat.CurrentTemperature = 35.5;

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
