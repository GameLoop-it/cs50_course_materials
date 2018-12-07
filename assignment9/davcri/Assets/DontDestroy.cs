using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DontDestroy : MonoBehaviour {

	// make this static so it's visible across all instances
	public static DontDestroy instance = null;

	// singleton pattern; make sure only one of these exists at one time, else we will
	// get an additional set of sounds with every scene reload, layering on the music
	// track indefinitely
	void Awake() {
		if (instance == null) {
			instance = this;
			DontDestroyOnLoad(gameObject);
		} else if (instance != this) {
			Destroy(gameObject);
		}
	}

	// Use this for initialization
	void Start () {
		
	}
}
