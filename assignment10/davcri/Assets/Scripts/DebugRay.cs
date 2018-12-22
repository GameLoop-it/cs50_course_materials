using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugRay : MonoBehaviour {
	
	// Update is called once per frame
	void Update () {

		// simply draws a ray going from a point in a direction
		Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * 1000, Color.red);
	}
}
