using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class Level : MonoBehaviour {
	public Text levelText;
	
	// Use this for initialization
	void Start () {
		levelText.text = "LEVEL " + StaticData.Level.ToString();
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
