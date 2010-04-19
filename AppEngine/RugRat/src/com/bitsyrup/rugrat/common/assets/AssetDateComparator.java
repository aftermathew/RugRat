package com.bitsyrup.rugrat.common.assets;

import java.util.Comparator;

public class AssetDateComparator implements Comparator<Asset>{

	@Override
	public int compare(Asset o1, Asset o2) {
		return o1.getCreated().compareTo(o2.getCreated());
	}
}
