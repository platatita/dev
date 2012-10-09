using System;
using System.Collections.Generic;
using System.Text;

namespace XmlDiff
{
	internal class Node
	{
		internal int Depth;
		internal string Name;
		internal string Text;
		internal Dictionary<string, string> AttributeCollection = new Dictionary<string, string>();
		internal bool Compared;
		internal Node Parent { get; private set; }

		protected Node ()
		{
		}

		internal Node (Node parent)
		{
			this.Parent = parent;
		}

		public override bool Equals (object obj)
		{
			Node objNode = obj as Node;
			if (objNode != null && !this.Compared)
			{
				return objNode.Depth == this.Depth &&
					objNode.Name == this.Name &&
					objNode.Text == this.Text &&
					objNode.AttributeCollection.Count == this.AttributeCollection.Count &&
					CompareAttributes(objNode.AttributeCollection);
						
			}
			
			return false;
		}
		
		public override int GetHashCode ()
		{
			return base.GetHashCode ();
		}
		
		private bool CompareAttributes (Dictionary<string, string> attributeCollection)
		{
			bool result = true;
			
			foreach(KeyValuePair<string, string> kvp in attributeCollection)
			{
				if (!this.AttributeCollection.ContainsKey(kvp.Key))
				{
					result = false;
					break;
				}
				
				result = kvp.Value == this.AttributeCollection[kvp.Key];
				if (!result)
				{
					break;
				}
			}
			
			return result;
		}
		
		public override string ToString ()
		{
			return string.Format ("Depth: {0}; Name: {1}; Text: {3}; Compared: {4}; AttrCount: {2}; AttrValues: {5}", 
				this.Depth,
				this.Name,
				this.AttributeCollection.Count,
				this.Text,
				this.Compared,
				AttributeCollectionToString());
		}
		
		private string AttributeCollectionToString ()
		{
			StringBuilder sb = new StringBuilder();
			
			foreach(KeyValuePair<string, string> kvp in this.AttributeCollection)
			{
				sb.AppendFormat("{0}:{1}", kvp.Key, kvp.Value);
				sb.AppendLine();
			}
			
			return sb.ToString();
		}
	}
}

