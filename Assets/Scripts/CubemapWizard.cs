using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class CubemapWizard : ScriptableWizard // 简单的界面编辑器
{
    public Transform renderFromPosition;
    public Cubemap cubemap;

    // Start is called before the first frame update
    void OnWizardCreate()
    {
        GameObject go = new GameObject( "CubemapCamera");
        go.AddComponent<Camera>();
        go.transform.position = renderFromPosition.position;
        go.GetComponent<Camera>().RenderToCubemap(cubemap);
        DestroyImmediate(go);
    }

    // Update is called once per frame
    void OnWizardUpdate()
    {
        helpString = "测试";
        isValid = (renderFromPosition != null) && (cubemap != null);
    }

    [MenuItem("GameObject/Render into Cubemap")]
    static void RenderCubemap () {
		ScriptableWizard.DisplayWizard<CubemapWizard>("Render cubemap", "Render!");
	}
}
