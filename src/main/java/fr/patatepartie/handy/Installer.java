package fr.patatepartie.handy;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;

import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.lib.StoredConfig;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;
import org.eclipse.jgit.transport.RefSpec;
import org.eclipse.jgit.transport.RemoteConfig;
import org.eclipse.jgit.transport.URIish;

import com.google.common.io.Files;

public class Installer {

	private static final String REPOSITORY_SUB_DIRECTORY = "repo";
	
	private File installationDirectory;
	private String originPath;
	private Repository repository;

	public Installer(File installationDirectory, String originPath) {
		this.installationDirectory = installationDirectory;
		this.originPath = originPath;
	}

	public static void main(String[] args) throws IOException, URISyntaxException {
		File installationDirectory = new File(args[0]);
		String originPath = args[1];
		
		Installer installer = new Installer(installationDirectory, originPath);
		installer.createInstallationDirectory();
		installer.createGitRepository();
		installer.addOriginRepository();
	}

	private void createInstallationDirectory() throws IOException {
		Files.createParentDirs(new File(installationDirectory, "anyChild"));
	}

	private void createGitRepository() throws IOException {
		repository = new FileRepositoryBuilder()
								.setWorkTree(new File(installationDirectory, REPOSITORY_SUB_DIRECTORY))
								.build();
		repository.create();
	}
	
	private void addOriginRepository() throws URISyntaxException, IOException {
		StoredConfig repositoryConfig = repository.getConfig();
		repositoryConfig.setString("branch", "master", "remote", "origin");
		repositoryConfig.setString("branch", "master", "merge", "refs/heads/master");
		
		RemoteConfig remoteConfig = new RemoteConfig(repositoryConfig, "origin");
		remoteConfig.addURI(new URIish(originPath));
		remoteConfig.addFetchRefSpec(new RefSpec("+refs/heads/*:refs/remotes/origin/*"));
		
		remoteConfig.update(repositoryConfig);
		repositoryConfig.save();
	}
}
