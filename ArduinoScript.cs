using Godot;
using System;
using System.IO.Ports;

//github change test
//test 2

	public partial class ArduinoScript : Node
	{
		public string serialMessage;

		SerialPort serialPort;
		RichTextLabel text;
		bool hasHeardFromArduino = false;
		float timer;

		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
		text = GetNode<RichTextLabel>("RichTextLabel");
		serialPort = new SerialPort();
		serialPort.PortName = "COM4";
		serialPort.BaudRate = 9600; //make sure this is the same in Arduino as it is in Godot.
		serialPort.Open();
	}

	public override void _Process(double delta)
	{
		if(!serialPort.IsOpen) return; //checks if serial port is open, if it's not do nothing.

		serialMessage = serialPort.ReadLine();
		//int value = int.Parse(serialMessage);
		//if(serialMessage.StartsWith("Hey")){
		//if(serialMessage > 10000){
			//GD.Print(serialMessage);
			//text.Text = "Hello Arduino, I hear you :)";
			//hasHeardFromArduino = true;
			//timer = Time.GetTicksMsec();
		//}else{
		//	GD.Print(serialMessage);
		//	text.Text = "";
		//}

		/*	if(hasHeardFromArduino && Time.GetTicksMsec() - timer > 3000){
				text.Text += "\n Turning on the Light for you :D";
				serialPort.Write("1");
				hasHeardFromArduino = false;
			}
			*/
	}
	}
