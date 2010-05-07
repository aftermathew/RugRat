package com.bitsyrup.rugrat.response;

public interface I_XMLSerializable {

	abstract String toXML();
	abstract void fromXML(String xml);
}
