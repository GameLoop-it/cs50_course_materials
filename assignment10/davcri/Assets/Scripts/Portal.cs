using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.Characters.FirstPerson;

public class Portal : MonoBehaviour {

	// the other portal that this will teleport to/render
	public GameObject linkedPortal;

	// used to help prevent us from infinitely teleporting back and forth
	private bool portalActive = true;

	void OnTriggerEnter(Collider other) {

		if (portalActive) {

			// make other portal not teleport us and our current one enabled
			linkedPortal.GetComponent<Portal>().Toggle();

			// OnExit never gets called after teleportation from a portal, so we
			// need to toggle manually
			Toggle();

			// cache player rotation to revert after teleport
			float xRot = other.transform.rotation.x;
			float zRot = other.transform.rotation.z;

			// set the player's position and rotation to the other portal's
			other.transform.SetPositionAndRotation(linkedPortal.transform.position, 
				Quaternion.identity);
			other.transform.rotation = linkedPortal.transform.parent.transform.rotation;

			// Y rotation from portal
			float yRot = other.transform.eulerAngles.y;

			// combine previously cached axes with new Y to get new rotation
			other.transform.eulerAngles = new Vector3(xRot, yRot, zRot);

			// override FPSController's mouse look caching
			other.GetComponent<FirstPersonController>().MouseReset();
		}
	}

	void OnTriggerExit(Collider other) {

		// re-enable this portal for teleportation after we've exited
		// (teleporting into it)
		Toggle();
	}

	public void Toggle() {

		// whether we can actually use this portal to teleport
		portalActive = !portalActive;
	}
}
