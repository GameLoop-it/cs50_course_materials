using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ValigettaScript : MonoBehaviour {

	public GameObject VictoryTextObject;
	private VictoryScript victoryScript;

	// Use this for initialization
	void Start () {
		victoryScript = VictoryTextObject.GetComponent<VictoryScript>();
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	void OnTriggerEnter(Collider other) {
		if (other.GetType() == typeof(UnityEngine.CharacterController)) {
			victoryScript.SetVictoryText();
		}
	}

}
