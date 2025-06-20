using Godot;
using System;
using System.IO.Ports;

public partial class ArduinoScript : Node
{
	private SerialPort serialPort;
	private int counter = 0;    
	
	[Export]
	public int SkipFrames { get; set; } = 15;

	[Signal]
	public delegate void CustomInputEventHandler(string arduinoValue); // ✅ Must end with 'EventHandler'

	public override void _Ready()
	{
		try
		{
			serialPort = new SerialPort
			{
				PortName = "COM4",
				BaudRate = 9600,
				ReadTimeout = 100
			};
			serialPort.Open();
			GD.Print("Serial port opened.");

			Connect("CustomInput", new Callable(this, nameof(OnCustomInput)));
		}
		catch (Exception ex)
		{
			GD.PrintErr("Error opening serial port: " + ex.Message);
		}
	}

	public override void _Process(double delta)
	{
		if (serialPort == null || !serialPort.IsOpen)
			return;

		//var serialMessage = serialPort.ReadLine().Trim();
	   // GD.Print("i got " + serialMessage);

		counter++;
		if (counter < SkipFrames) {
		   return;
		}
		counter = 0; 
			   
		try
		{
			var serialMessage = serialPort.ReadLine().Trim();
			//var serialMessage = "1";
			GD.Print("Received from Arduino: " + serialMessage);

			EmitSignal("CustomInput", serialMessage);
		}
		catch (TimeoutException)
		{
			// Ignore timeouts (no data)
		}
		catch (Exception ex)
		{
			GD.PrintErr("Error reading from serial: " + ex.Message);
		}
	}

	private void OnCustomInput(string arduinoValue)
	{
	   // GD.Print("Received from Arduino: " + arduinoValue);
	}


	public override void _ExitTree()
	{
		if (serialPort != null && serialPort.IsOpen)
		{
			serialPort.Close();
			GD.Print("Serial port closed.");
		}
	}
}
