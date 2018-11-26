using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour {
    public GameObject[] prefabs;

    // Use this for initialization
    void Start () {
        StartCoroutine(spawnGems());
    }
	
    IEnumerator spawnGems() {
        while (true)
        {
            Instantiate(
                prefabs[0], 
                new Vector3(26, Random.Range(-10, 10), 10), 
                Quaternion.identity);
            yield return new WaitForSeconds(2);
        }
    }

	// Update is called once per frame
	void Update () {
        transform.position = new Vector3(transform.position.x - 5, transform.position.y, transform.position.z);

    }
}
