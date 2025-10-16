We take security very seriously.

If you believe you have found a security concern, please [file an issue](https://github.com/PowerShellWeb/OpenXML) describing the issue.

Each project may have some special security considerations that you may need to be aware of.

## Special Security Considerations

OpenXML has some fairly unique security considerations.  Any tooling for OpenXML will inherit these concerns.

### OpenXML Smuggling

OpenXML files are essentially `.zip` files with a different extension.

As such, there is a grand history of using OpenXML and other archive files to hide exploits.

Additionally, unrecognized content within an OpenXML document is often not displayed in any form of the editor.  

It is the opinion of the author that this would be a wonderful thing to flag during load.

If you work on a program that edits OpenXML documents, please strongly consider this.

As it stands, OpenXML smuggling is very easy.

As this module can read and write OpenXML packages, it makes OpenXML smuggling both easier to perform and easier to detect.

If you see this module deployed in unexpected places, please use this module to search for OpenXML smuggled content.

### OpenXML Data Scanning

Word, Excel, and PowerPoint files may all contain personally identifiable information.

Any tool capable of automatically interacting with office documents can be used to scan for sensitive information.

This can help the blue team find targets just as much as the red team.

This is far from the first tool to automate OpenXML, and so this threat is not unique to this tool.

It is always important to mind your PII, and this tool will help you locate this information.

To protect a file containing PII from inspection, add a password protection or encrypt the file. 

### OpenXML Microservers

OpenXML files also contain content type information, which allows them to act as effecient servers.

This can be quite useful for local multiprogram access and for development of small microservers.

When used to serve an OpenXML document, these microservers may make it easy to exfiltrate information if they are exposed to the broader internet.

If you see a public facing endpoint serving an OpenXML document, contact your network administrator and cybersecurity teams.

Additionally, when combined with the OpenXML Smuggling techniques mentioned earlier, it is possible to host a server with _any_ content inside of an OpenXML file.

Please use this tool to proactively scan for this possibility.