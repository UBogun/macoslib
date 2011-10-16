#tag Class
Protected Class KeychainItem
Inherits CFType
	#tag Event
		Function ClassID() As UInt32
		  return ClassID
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		 Shared Function ClassID() As UInt32
		  #if targetMacOS
		    declare function TypeID lib KeychainServices.framework alias "SecKeychainItemGetTypeID" () as UInt32
		    static id as UInt32 = TypeID
		    return id
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Data() As String
		  #if targetMacOS
		    declare function SecKeychainItemCopyAttributesAndData lib KeychainServices.framework (itemRef as Ptr, info as Ptr, itemClass as Ptr, attrList as Ptr, ByRef length as UInt32, ByRef data as Ptr) as Integer
		    declare function SecKeychainItemFreeAttributesAndData lib KeychainServices.framework (attrList as Ptr, data as Ptr) as Integer
		    
		    dim length as UInt32
		    dim outData as Ptr
		    dim err as Integer = SecKeychainItemCopyAttributesAndData(self, nil, nil, nil, length, outData)
		    if err = Error.Success then
		      dim m as MemoryBlock = outData
		      dim data as String = m.StringValue(0, length)
		      err = SecKeychainItemFreeAttributesAndData(nil, outData)
		      if err = Error.Success then
		        return data
		      else
		        raise new Error(err)
		      end if
		    else
		      raise new Error(err)
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Data(assigns value as String)
		  #if targetMacOS
		    declare function SecKeychainItemModifyAttributesAndData lib KeychainServices.framework (itemRef as Ptr, attrList as Ptr, length as UInt32, data as CString) as Integer
		    
		    dim err as Integer = SecKeychainItemModifyAttributesAndData(self, nil, LenB(value), value)
		    if err <> Error.Success then
		      raise new Error(err)
		    end if
		  #endif
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Description"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="CFType"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
