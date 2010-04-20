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
		if (order.compareTo("date") == 0)
		{
			c = new AssetDateComparator();
		}
		else if (order.compareTo("name") == 0)
		{
			c = new AssetNameComparator();
		}
		else if (order.compareTo("size") == 0)
		{
			c = new AssetSizeComparator();
		}
		else if (order.compareTo("type") == 0)
		{
			c = new AssetTypeComparator();
		}
		else return;

		Collections.sort(this, c);
	}
	
	public void reverse()
	{
		int sz = this.size();
		int lt = 0;
		int rt = sz - 1;
		Asset temp;
		while (lt < rt)
		{
			temp = this.elementAt(lt);
			this.set(lt, this.elementAt(rt));
			this.set(rt, temp);
			lt++;
			rt--;
		}
	}
}
