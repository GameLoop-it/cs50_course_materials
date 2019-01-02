using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalGun : MonoBehaviour {

	private AudioSource portalSound;
	private AudioSource errorSound;

	public GameObject orangePortal;
	public GameObject bluePortal;
	public GameObject gunTip;

	// Use this for initialization
	void Start () {
		portalSound = GetComponents<AudioSource>()[0];
		errorSound = GetComponents<AudioSource>()[1];
	}
	
	// Update is called once per frame
	void Update () {

		// fire the right portal (left or right) based on input
		if (Input.GetButtonDown("Fire1")) {
			FirePortal("orange");
		} else if (Input.GetButtonDown("Fire2")) {
			FirePortal("blue");
		}
	}

	void FirePortal(string type) {

		// struct object that will hold our raycast information
		RaycastHit hit;

		// if we collide with an object with our raycast, spawn a portal there
		if (Physics.Raycast(gunTip.transform.position, transform.TransformDirection(Vector3.forward), out hit, Mathf.Infinity)) {
			portalSound.Play();
			
			// choose between the correct portals based on string input
			GameObject portal = type == "orange" ? orangePortal : bluePortal;

			// set the portal to the same position as the raycast point, and set
			// its rotation to orient to the wall relative to what its "up" direction is,
			// which is Vector.up in world space 
			portal.transform.SetPositionAndRotation(hit.point, Quaternion.FromToRotation(Vector3.forward, hit.normal));
		} else {
			errorSound.Play();
		}
	}
}
