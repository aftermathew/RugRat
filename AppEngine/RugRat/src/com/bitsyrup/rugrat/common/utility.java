package com.bitsyrup.rugrat.common;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class utility {
	public static byte[] hashHmacSHA1(String base, String key)
	{
		byte[] baseBytes = base.getBytes();
		byte[] keyBytes = base.getBytes();
		return hashHmacSHA1(baseBytes, keyBytes);
	}
	
	public static byte[] hashHmacSHA1(byte[] base, byte[] key)
	{
		try
		{
			SecretKeySpec signingKey = new SecretKeySpec(key, "HmacSHA1");
			Mac mac = Mac.getInstance("HmacSHA1");
			mac.init(signingKey);
			byte[] rawHmac = mac.doFinal(base);
			return rawHmac;
		}
		catch (Exception e)
		{
			return null;
		}
	}
	
	private static String base64AlphaStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	// home-crafted b64 encoder, since Google does not support sun.misc.*
	public static String base64Encode(byte[] bytes) 
	{
		StringBuilder sb = new StringBuilder();
		int val;
		for (int i = 0; i < bytes.length;) 
		{
			val = (bytes[i] & 0xFC) >> 2;
			sb.append(base64AlphaStr.charAt(val));
			val = (bytes[i++] & 0x03) << 4;
			if (i < bytes.length) 
			{
				val |= (bytes[i] & 0xF0) >> 4;
			}
			sb.append(base64AlphaStr.charAt(val));
			val = 64; // '='
			if (i < bytes.length) 
			{
				val = (bytes[i++] & 0x0F) << 2;
				if (i < bytes.length) 
				{
					val |= (bytes[i] & 0xC0) >> 6;
				}
			} 
			else 
			{
				i++;
			}
			sb.append(base64AlphaStr.charAt(val));
			val = 64; // '='
			if (i < bytes.length) 
			{
				val = (bytes[i] & 0x3F);
			}
			sb.append(base64AlphaStr.charAt(val));
			i++;
		}
		return sb.toString();
	}

	public static byte[] base64Decode(String b64Str) 
	{
		int b64Len = b64Str.length();
		int bytesLen = ((b64Len + 3) / 4) * 3; // ceiling
		if (b64Len > 2 && b64Str.charAt(b64Len - 1) == '=') 
		{
			if (b64Str.charAt(b64Len - 2) == '=') 
			{
				bytesLen -= 1;
				if ((b64Str.charAt(b64Len - 3) & 0x0F) == 0x00) 
				{
					bytesLen -= 1;
				}
			} 
			else if ((b64Str.charAt(b64Len - 2) & 0x03) == 0x00) 
			{
				bytesLen -= 1;
			}
		}
		byte[] bytes = new byte[bytesLen];
		byte val;
		for (int i = 0, curByte = 0; i < b64Len && curByte < bytesLen; ) 
		{
			// 1st byte val
			val = (byte) (base64AlphaStr.indexOf(b64Str.charAt(i++)) << 2);
			val |= (byte) ((base64AlphaStr.indexOf(b64Str.charAt(i)) & 0x30) >> 4);
			bytes[curByte++] = val;
			if (curByte >= bytesLen) break;
			// 2nd byte val
			val = (byte) ((base64AlphaStr.indexOf(b64Str.charAt(i++)) & 0x0F) << 4);
			int b64Val = (base64AlphaStr.indexOf(b64Str.charAt(i)));
			val |= (byte) ((b64Val < 64) ? ((b64Val & 0x3C) >> 2) : 0x00);
			bytes[curByte++] = val;
			if (curByte >= bytesLen) break;
			// 3rd byte val
			if (b64Val < 64) 
			{
				val = (byte) ((b64Val & 0x03) << 6);
				b64Val = (base64AlphaStr.indexOf(b64Str.charAt(++i)));
				if (b64Val != 64) 
				{
					val |= (byte) b64Val;
				}
				bytes[curByte++] = val;
			} 
			else 
			{
				i++;
			}
		}
		// HACK - need to fix one-off (error adds trailing 0 byte)
		if (bytes[bytes.length - 1] == 0) 
		{
			byte[] newBytes = new byte[bytes.length - 1];
			for (int i = 0; i < bytes.length - 1; i++) 
			{
				newBytes[i] = bytes[i];
			}
			return newBytes;
		} 
		else
		{
			return bytes;
		}
	}
	

	//acceptable chars in parameter encoding are A-Z, a-z, 0-9, - _ . and ~
	//note: hex chars MUST be in uppercase.
	//input must be UTF-8 prior to encoding
	public static String parameterURLEncode(String initStr)
	{
		String unreserved = "_-.~";
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < initStr.length(); i++)
		{
			char c = initStr.charAt(i);
			if (Character.isLetterOrDigit(c) || unreserved.indexOf(c) >= 0)
			{
				sb.append(c);
			}
			else
			{
				byte b = (byte)c;
				sb.append('%');
				char c2 = (char)(((b & 0xF0) >> 4) + '0');
				if (c2 > '9') c2 = (char)(c2 - '9' - 1 + 'A');
				sb.append(c2);
				c2 = (char)((b & 0x0F) + '0');
				if (c2 > '9') c2 = (char)(c2 - '9' - 1 + 'A');
				sb.append(c2);
			}
		}
		return sb.toString();
	}
	
	public static String parameterURLDecode(String initStr)
	{
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < initStr.length(); i++)
		{
			char c = initStr.charAt(i);
			if (c == '%')
			{
				c = initStr.charAt(++i);
				byte b = (c <= '9') ? (byte)(c - '0') : (byte)(c - 'A' + 10);
				b <<= 4;
				c = initStr.charAt(++i);
				b |= (c <= '9') ? (byte)(c - '0') : (byte)(c - 'A' + 10);
				c = (char)b;
			}
			sb.append(c);
		}
		return sb.toString();
	}
}
