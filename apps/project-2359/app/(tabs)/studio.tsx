import { View, ScrollView, Pressable } from 'react-native';
import { H2, H3, P, Muted } from '@/components/ui/typography';
import { Card, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Folder, File, MoreVertical, CheckCircle2, Loader2, Plus } from 'lucide-react-native';

export default function StudioScreen() {
    return (
        <View className="flex-1 bg-white">
            <ScrollView className="flex-1 p-4">
                <View className="mt-12 mb-6 flex-row justify-between items-center">
                    <H2>Studio</H2>
                    <Button variant="ghost" size="icon">
                        <Plus size={24} color="black" />
                    </Button>
                </View>

                <View className="mb-6">
                    <H3 className="mb-4">Hierarchy</H3>
                    <View className="space-y-2">
                        <Pressable className="flex-row items-center p-3 bg-gray-50 rounded-lg mb-2">
                            <Folder size={20} color="black" />
                            <P className="ml-3 font-medium">Semester 1</P>
                        </Pressable>
                        <View className="ml-6">
                            <Pressable className="flex-row items-center p-3 bg-gray-50 rounded-lg mb-2">
                                <Folder size={20} color="black" />
                                <P className="ml-3 font-medium">Anatomy</P>
                            </Pressable>
                            <View className="ml-6">
                                <Pressable className="flex-row items-center p-3 bg-gray-100 rounded-lg mb-2">
                                    <File size={20} color="black" />
                                    <P className="ml-3">Module 1: Skeletal System</P>
                                </Pressable>
                            </View>
                        </View>
                    </View>
                </View>

                <H3 className="mb-4">Resources</H3>
                <View className="space-y-4">
                    <Card className="mb-4">
                        <CardHeader className="flex-row items-center justify-between p-4">
                            <View className="flex-row items-center flex-1">
                                <File size={24} color="black" />
                                <View className="ml-3">
                                    <CardTitle className="text-base">Lecture_Notes_V1.pdf</CardTitle>
                                    <View className="flex-row items-center">
                                        <CheckCircle2 size={14} color="green" />
                                        <Muted className="ml-1 text-green-600">Processed</Muted>
                                    </View>
                                </View>
                            </View>
                            <MoreVertical size={20} color="gray" />
                        </CardHeader>
                    </Card>

                    <Card className="mb-4">
                        <CardHeader className="flex-row items-center justify-between p-4">
                            <View className="flex-row items-center flex-1">
                                <File size={24} color="black" />
                                <View className="ml-3">
                                    <CardTitle className="text-base">Lab_Results.pdf</CardTitle>
                                    <View className="flex-row items-center">
                                        <Loader2 size={14} color="blue" className="animate-spin" />
                                        <Muted className="ml-1 text-blue-600">Generating...</Muted>
                                    </View>
                                </View>
                            </View>
                            <MoreVertical size={20} color="gray" />
                        </CardHeader>
                    </Card>
                </View>
            </ScrollView>

            <View className="absolute bottom-6 right-6">
                <Button className="h-14 w-14 rounded-full shadow-lg" size="icon">
                    <Plus size={30} color="white" />
                </Button>
            </View>
        </View>
    );
}
