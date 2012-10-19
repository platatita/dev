using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;

namespace XmlDiff
{
	internal class XmlConverter : BaseReader
	{
		private readonly string xml;
		
		internal XmlConverter (string xml)
			: base()
		{
			this.xml = xml;
		}
		
		internal List<Node> Convert()
		{
			Root root = new Root();

			Queue<Node> queue = new Queue<Node>();
			queue.Enqueue (root);

			Node parent = null;
			Node lastNode = null;
			int lastDepth = 0;
			
			using (StringReader sr = new StringReader(this.xml))
			{
				using (base.xmlReader = XmlReader.Create(sr))
				{					
					List<Node> nodeCollection = new List<Node>();
					
		            while (!base.xmlReader.EOF && base.xmlReader.Read())
		            {
		                if (base.IsStartElement())
		                {
							if (base.xmlReader.Depth == 0)
							{
								parent = root;
							}
							else if (lastDepth < base.xmlReader.Depth)
							{
								parent = lastNode;
							}

							Node currentNode = new Node(parent);
							lastNode = currentNode;
							queue.Enqueue (currentNode);
							
							lastDepth = currentNode.Depth = base.xmlReader.Depth;
							currentNode.Name = base.xmlReader.Name;

							if (base.xmlReader.HasAttributes)
							{
								ReadAttributes(currentNode);
							}

							if (base.xmlReader.HasValue)
							{
								currentNode.Text = base.xmlReader.Value;
							}
							
							nodeCollection.Add(currentNode);
						}
						else if (base.IsEndElement ())
						{
							lastDepth = base.xmlReader.Depth;
							
							parent = queue.Dequeue ();
						}
					}
					
					return nodeCollection;
				}
			}
		}

		private void ReadAttributes (Node node)
		{
			node.AttributeCollection = new Dictionary<string, string>();
			
			for(int i = 0; i < base.xmlReader.AttributeCount; i++)
			{
				base.xmlReader.MoveToAttribute(i);
				
				node.AttributeCollection.Add(base.xmlReader.Name, base.xmlReader.GetAttribute(i));
			}
			
			base.xmlReader.MoveToElement();
		}
	}
}

