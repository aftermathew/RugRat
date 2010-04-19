package com.bitsyrup.rugrat.common.assets;


import java.util.Collections;
import java.util.Comparator;
import java.util.Vector;

public class AssetList extends Vector<Asset>{

	/**
	 * general id for compilation blessing - serialization need...
	 */
	private static final long serialVersionUID = 1L;
	
	@SuppressWarnings("unchecked")
	public void sort(String order)
	{
		Comparator c;
		if (order == "date")
		{
			c = new AssetDateComparator();
		}
		else if (order == "name")
		{
			c = new AssetNameComparator();
		}
		else if (order == "size")
		{
			c = new AssetSizeComparator();
		}
		else if (order == "type")
		{
			c = new AssetTypeComparator();
		}
		else return;

		Collections.sort(this, c);
	}
}
