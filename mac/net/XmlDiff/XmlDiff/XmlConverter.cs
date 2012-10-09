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

			Node currentNode = null;

			using (StringReader sr = new StringReader(this.xml))
			{
				using (base.xmlReader = XmlReader.Create(sr))
				{					
					List<Node> nodeCollection = new List<Node>();
					
		            while (!base.xmlReader.EOF && base.xmlReader.Read())
		            {
		                if (base.IsStartElement())
		                {
							Node parent = currentNode ?? root;

							currentNode = new Node(parent);
							queue.Enqueue (currentNode);
							
							currentNode.Depth = base.xmlReader.Depth;
							currentNode.Name = base.xmlReader.Name;

							if (base.xmlReader.HasAttributes)
							{
								ReadAttributes(currentNode);
							}

							if (base.xmlReader.HasValue)
							{
								currentNode.Text = base.xmlReader.Value;
							}
						}
						else if (base.IsEndElement ())
						{
							nodeCollection.Add(currentNode);
							
							currentNode = queue.Dequeue ();
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
		}
	}
}

