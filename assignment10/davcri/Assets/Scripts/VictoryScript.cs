using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class VictoryScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
		// hide the Victory text
		GetComponent<Text>().text = "";
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void SetVictoryText() {
		GetComponent<Text>().text = "You Won!\nCS50 completed!";
	}


} 
